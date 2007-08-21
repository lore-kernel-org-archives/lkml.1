Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbXHUT1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbXHUT1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 15:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXHUT1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 15:27:34 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:27468 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXHUT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 15:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=W1S8ZdZl8r2mhHuGEnttyC8TipKLsBKmcAryFTk/+VGvikPzYtlJ7ffWihtq59cZbw5nRIr44SI0hI7eVNE21Vq49cTI3X8lkukOSGnzmJbCN8JQ5v4LlgsSAIt4ZFyyCLd78IvdfJPskq/Ajy/aiv0mGUPJb+WVVW8/LTYOkNQ=
Message-ID: <5dc6fd9e0708211227k22f9e214vd8132913214716b3@mail.gmail.com>
Date: Tue, 21 Aug 2007 12:27:25 -0700
From: "Hex Star" <hexstar@gmail.com>
To: "=?ISO-8859-1?Q?Ismail_D=F6nmez?=" <ismail@pardus.org.tr>,
       linux-kernel@vger.kernel.org
Subject: Re: Trouble booting with new 2.6.22.3 kernel
In-Reply-To: <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5dc6fd9e0708211219p679116a4n48765e72e2253ddc@mail.gmail.com>
	 <200708212225.51987.ismail@pardus.org.tr>
	 <5dc6fd9e0708211226k3f931579x6f8b3ab275f93c35@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Hex Star <hexstar@gmail.com> wrote:

> Ah so the IDE/SATA driver should not be a module (if it is a module
> it'll cause this issue)?
>

One more thing, are there any other critical kernel components that
won't work as a module and thus prevent boot?

Thanks! :)
