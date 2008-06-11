Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbYFKI7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbYFKI7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 04:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYFKI7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 04:59:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:21149 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbYFKI7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 04:59:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=mufgUEDfqKExoZkIWKoPmQcOurZUX1TMzVm/3AfHXyTX87uXPTniMadL7u55HSPly7
         k02P8HXuT15jmxAnRkLme5mcxZcIDh/wqUYZiKIYJ0U8I13bYlqbWstHEJVRCLseJ4jn
         kLf6PNobzfs7XEjYCafSO43fQu5c0t6CDunX0=
Message-ID: <46d6db660806110159k284b2ee9s62e118b8d09258bb@mail.gmail.com>
Date: Wed, 11 Jun 2008 10:59:11 +0200
From: "Christian MICHON" <christian.michon@gmail.com>
To: "Tim Bird" <tim.bird@am.sony.com>
Subject: Re: mainlining min-configs...
Cc: "Rob Landley" <rob@landley.net>, linux-tiny <Linux-tiny@selenic.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       "Adrian Bunk" <adrian.bunk@movial.fi>
In-Reply-To: <484DDAD9.2000306@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48447615.5050806@am.sony.com>
	 <20080604194002.GF4189@cs181133002.pp.htv.fi>
	 <4849CCA3.7040102@am.sony.com> <200806062329.54019.rob@landley.net>
	 <484DDAD9.2000306@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 3:37 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> Any chance of getting your minimal configs from Firmware Linux mainlined?
>
> Does anyone else think this would be valuable?  If not in mainline, it
> would be nice to collect them somewhere, to compare what options different
> developers decide turn on or off.
>  -- Tim
>

this is very valuable. DetaolB uses this concept. Download the latest
iso of DetaolB, boot it and look for /proc/miniconfig.gz.
you'll see an example for 2.6.23 there.

you can find old patches there:
http://downloads.sourceforge.net/detaolb/detaolb_v03-linux-2.6.21.patch

-- 
Christian
--
http://detaolb.sourceforge.net/, a linux distribution for Qemu with Git inside !
