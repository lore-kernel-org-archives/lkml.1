Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbXJULwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbXJULwv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXJULwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:52:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.233]:36060 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXJULwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fQ8fXEpQpThy7wycdQ6dAOXU3/SoIgH8PC9CrernJkuEJ0h1gugR1254gRI1Wv/CO1/jAsgGXnLpi8RDI4KkOFa3wAWrIaH0oQz1vWjjZySZByLSQsMc34FiL3CGisAseBIjMf2p5VFEX2GaQrQ/zOH8V96D/ooUCi6iWNOHyw8=
Date: Sun, 21 Oct 2007 19:48:54 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Nix <nix@esperi.org.uk>
Cc: Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in
	2.6.23-final.
Message-ID: <20071021114854.GF2455@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y7dyhv2u.fsf@hades.wkstn.nix>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 12:41:29PM +0100, Nix wrote:
>On 20 Oct 2007, Paolo Giarrusso told this:
>> Guess most people are not using SMP right now, and that the error disappears 
>> without that setting
>
>It doesn't. It fails with non-SMP as well.
>

UML still doesn't build on 2.6.23-git16.

Gcc threw out many errors, I put them in the web:
	http://wangcong.org/down/errors.txt

My .config is located at:
	http://wangcong.org/down/uml_config.bak

Or I missed something?

Regards.

-- 
May the Source Be With You.
