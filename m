Return-Path: <linux-kernel-owner+w=401wt.eu-S1762653AbXGFAxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762653AbXGFAxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760983AbXGFAxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:53:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:33782 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760922AbXGFAxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bS8kl9lg2wvZ7QsaUDtrzjuktHdrabVGBBfnoIx6QQBcL3A2SxpgKXBmZlHR7IwTHN2SMYo91ANK8V0Y5knHpHo32vz9H9eQMDmQpuXpuXWIFfvPkBrKddUgGrYaVqQPlSYrXmKiBlXshNrULh1fOkX7JF1MJ1cyXwh6X6YbX/s=
Message-ID: <f8b2ccd40707051753v7cba58cfw1d3e0df5e4decc6d@mail.gmail.com>
Date: Thu, 5 Jul 2007 17:53:11 -0700
From: "Gautam Singaraju" <gautam.singaraju@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: RSA support into kernel?
In-Reply-To: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f8b2ccd40707051548w275a1575oaaddffd40d9a9163@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any attempt being made to provide software based RSA
cryptographic support in kernel? I see that Linux supports
Hardware based cryptographic devices (VIA Padlock ACE). How is the
performance of such hardware? How well are these devices supported?
-GS
