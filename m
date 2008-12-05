Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYLEQLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYLEQLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbYLEQLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:11:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:49850 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYLEQLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:11:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JcOJXqYRY7ZcH1yIue9lNjfHB4attUWWLY1PLjMwIKPKbXl5q+VL89AkzflMjlRtwH
         4ZGG+m463eyoT8B6UcyiVuACgsu6/SZhuFpxcfnPREMs/Tdxlty/SYlDBmQ+8Qv2dROi
         eSOOADcAsVQGDQ9zTz8xCH+c1bjvOzEecbFy0=
Message-ID: <8bd0f97a0812050811y316299bbrb9eb415128d978c5@mail.gmail.com>
Date: Fri, 5 Dec 2008 11:11:40 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Nick Andrew" <nick@nick-andrew.net>
Subject: Re: [PATCH] Fix incorrect use of loose in cpufreq.c
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "Dominik Brodowski" <linux@dominikbrodowski.net>,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       "Vitja Makarov" <vitja.makarov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081205035011.922.75349.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205035011.922.75349.stgit@marcab.local.tull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 22:50, Nick Andrew wrote:
> Fix incorrect use of loose in cpufreq.c
>
> It should be 'lose', not 'loose'.

thanks ... ive stuck it into our tree
-mike
