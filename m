Return-Path: <linux-kernel-owner+w=401wt.eu-S1752744Ab0A2GfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab0A2GfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384Ab0A2GfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:35:22 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:60481 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab0A2GfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:35:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uKsxuqGEgl6QIMnd4rzKOcHZEnO95PPYARyvcU0KEYmSHgj1FXiOZiP5wXJgoZqX71
         Yyyx+pxVClr+ZaghL32Iw6U8WnjaxNyIQkFAE81F2s+qEMglKw16PVDSsylUiZ60g/Mn
         PJcAPq9HHDq8icw/XOXjSCqilmulIOSdyjn9M=
Date: Thu, 28 Jan 2010 22:35:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] winbond-cir: remove dmesg spam
Message-ID: <20100129063516.GB4177@core.coreip.homeip.net>
References: <20100128195712.GA9005@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100128195712.GA9005@hardeman.nu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 08:57:12PM +0100, David Härdeman wrote:
> I missed converting one dev_info call to deb_dbg before submitting the driver.
> Without this change, a message will be printed to dmesg for each button press
> if a RC6 remote is used.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> Cc: stable <stable@kernel.org>

Applied, than you David.

-- 
Dmitry
