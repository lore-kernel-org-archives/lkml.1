Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbZLFVJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbZLFVJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:09:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934195AbZLFVJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:09:06 -0500
Received: from smtprelay03.ispgateway.de ([80.67.31.37]:54528 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934162AbZLFVJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:09:06 -0500
References: <2a6e8c0d0912052133v3e112bdbx2c95b17437bdd182@mail.gmail.com> <cone.1260110279.127989.3159.1000@onepiie> <2a6e8c0d0912060712n32fa2890r9055ddbac440366a@mail.gmail.com>
Message-ID: <cone.1260133750.467790.3159.1000@onepiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Ian =?UTF-8?B?RS4=?= Morgan <penguin.wrangler@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: acerhdf: BIOS product mismatch due to whitespace
Date: Sun, 06 Dec 2009 22:09:10 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian E. Morgan writes:

> On Sun, Dec 6, 2009 at 09:37, Peter Feuerer <peter@piie.net> wrote:
>>
>> could you please be so kind and test:
>> http://piie.net/files/acerhdf_kmod-0.5.22.tar.gz
> 
> Yep, that does the trick nicely. Thanks. Are you submitting that for .32-stable?

I'll provide a patch for -mm and I think this patch can be also applied to .32

thanks again for reporting and testing,
--peter
