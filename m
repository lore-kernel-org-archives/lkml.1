Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbZERJu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbZERJu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757387AbZERJno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:43:44 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:22531 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758756AbZERJnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ONB+NJNgZABQ8QB9WXrF9n1Lqy9eGLhggVyQWPQZyk2B5jieNg1YYDQDsfklXkwagy
         Yo6ozn0kicCkJKl3LVU0qCuz/tqJcGctLFZkKPLFfUt4nD/rH4tstqkz/Bg6BpPhtJw7
         DLBaxUgswWpd4a8l5didqiBvaKG+ji9vi2qcc=
Date: Mon, 18 May 2009 17:45:01 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Renzo Davoli <renzo@cs.unibo.it>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net, mtk.manpages@gmail.com,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 0/2] ptrace_vm: ptrace for syscall emulation virtual
	machines
Message-ID: <20090518094501.GB13776@cr0.nay.redhat.com>
References: <20090316074520.GC3360@hack> <20090324234753.GH22695@cs.unibo.it> <20090329163228.GE7671@hack> <20090404101708.GG4203@cs.unibo.it> <20090407173646.GL12226@hack> <20090408121851.GE24173@cs.unibo.it> <20090413163603.GG2391@hack> <20090417081823.GA31897@hack> <20090425091928.GB18153@cs.unibo.it> <20090430082711.GA24819@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090430082711.GA24819@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 04:27:11PM +0800, Américo Wang wrote:
>On Sat, Apr 25, 2009 at 11:19:28AM +0200, Renzo Davoli wrote:
>
>>
>>I have successfully tested my paches in various configurations:
>>- patched-kernel running patched-UML
>>- patched-kernel running unpatched-UML
>>- patched-kernel running umview
>>- patched-UML running umview
>>- UML on UML fails in the same way with and without the patch.
>>I am currently running the patched kernel on my laptop.
>
>Thanks, I will give them another testing soon...

Sorry for the long delay...

I reviewed the whole patch set again, and tested it on both i386
and x86_64, it looks very fine!! :-)

So I would like to see these patches to be merged.

Andrew, could you please take these two patches for us??

Thank you!

