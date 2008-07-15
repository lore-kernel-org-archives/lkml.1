Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbYGOEsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbYGOEsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 00:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbYGOEsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 00:48:32 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:10897 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYGOEsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 00:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GhTI1CDvW0hVdaHOHh/1x6ZY763AcPlcZ62luHc/a/ppZECWhlUgTWA5CBOShWENxI
         GtlOZUIw9FixSKEJBzHwV2fMsWPqoK0DpQx+kXRkw2iwwiyiuDAnlzC2C31AIk7lOetQ
         YVo5oFYB2GFo5Rh6VbCamnTHEefy4y4Zw4t7M=
Message-ID: <9b2db90b0807142148o77c0bb7au7560cb5bd2d97f7@mail.gmail.com>
Date: Tue, 15 Jul 2008 07:48:29 +0300
From: "Nir Tzachar" <nir.tzachar@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: Problems with resume from s2ram following hibernate
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080712133236.GA14877@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9b2db90b0807100200h5e1eabaapada93d8e5cc3ec79@mail.gmail.com>
	 <9b2db90b0807100202l53df9364tf36c5dfaf18bf1f5@mail.gmail.com>
	 <20080712133236.GA14877@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 4:32 PM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> I am currently using kernel 2.6.25 (with Gentoo patches), and have had
>> the problem ever since I managed to get suspend to disk working. One
>> issue which might be related is that I boot my kernel with
>> "acpi_serialize", as otherwise I get many acpi error messages.
>
> Try vanilla 2.6.26-rc... we can't debug vendor kernels here.

Ok, will report any problems.

10x.
