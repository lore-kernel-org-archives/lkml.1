Return-Path: <linux-kernel-owner+w=401wt.eu-S1030223AbXBFWsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223AbXBFWsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 17:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030224AbXBFWsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 17:48:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:4987 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030223AbXBFWsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 17:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hBS8i/mRcNJOYSTiyfMD2jTV6Q+X9aDmqJQYcGx36U7dk50UtdALqgxIbgF4po8e9Ss6mKBNzIYlVFPpBcyUbV87Out16aIFozrjCStWOqdZ31Og/omo3Luj5bT2bf/1d5p+oNz6TGmClS5+YCQH/pwHRNvdMU+Ny7GWqUyzEF8=
Message-ID: <58cb370e0702061448o300c5378p19fb7999d11e109c@mail.gmail.com>
Date: Tue, 6 Feb 2007 23:48:50 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ide section fixes
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1HCcMg-0007QC-Vk@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1HCcMg-0007QC-Vk@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Al Viro <viro@ftp.linux.org.uk> wrote:
>
> a) cleanup_module() should be __exit
> b) externs should match reality
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

applied, thanks
