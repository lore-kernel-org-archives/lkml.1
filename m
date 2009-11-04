Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbZKDJOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbZKDJOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbZKDJOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:14:22 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:40527 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbZKDJOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:14:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=K4DLlMBeTVttW3L8tNmBSBhU9CQzKRgXmNB4Tjo3lBSIM3HhR5VOGrbUpjeUoIFXWP
         wDN9A7maPczB1LmOYGPu6f/+fMwo9eMx6N/bCd4JdUTTctfkZGUoqQot3Qc92hG1kiL4
         GcWl7yFNzhRf/6pcnsNcMinFHw+l9LEefYkCE=
Message-ID: <4AF145EE.70907@gmail.com>
Date: Wed, 04 Nov 2009 10:14:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gcc@gcc.gnu.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@cs.washington.edu>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com> <20091103222432.4a94bd8f.akpm@linux-foundation.org> <4AF122BB.7000202@gmail.com>
In-Reply-To: <4AF122BB.7000202@gmail.com>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 07:44 AM, Justin P. Mattock wrote:
> as for compiling: libc compiled fine, kernel fine,
> and every package on the clfs list up to boot up the fresh system.

It might be pretty c++ only, I think.
