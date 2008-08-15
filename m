Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYHOQRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYHOQRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760514AbYHOQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:17:21 -0400
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:49871 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760430AbYHOQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:17:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=F5r9t2F9RFe3FSDVtSkBMHf0BQTlLMG0iAvTNbVSlqUkcCIrb9k1sEmYQbMg2xFnxJNwQA0lGXShQP0hd4EPl7xBOZrHIv2meeOMlvoQ2b7S3pZrafI37E9jqxAZIS72;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Subject: Re: [PATCH 2.6.26.2][RESEND] irq: irq and pci_ids patch for Intel Ibex Peak DeviceIDs
Date: Fri, 15 Aug 2008 09:17:11 -0700
User-Agent: KMail/1.9.9
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, khali@linux-fr.org
References: <200808111701.50662.seth.heasley@intel.com>
In-Reply-To: <200808111701.50662.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808150917.12214.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 11, 2008 5:01 pm Seth Heasley wrote:
> Resend with proper whitespace.
>
> This patch adds the Intel Ibex Peak (PCH) LPC and SMBus Controller
> DeviceIDs.
>
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Somehow the whitespace was still damaged, but I fixed it up by hand.  It's 
applied to my for-linus branch so it'll be included in the next pull request 
I send to Linus.

Thanks,
Jesse
