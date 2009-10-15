Return-Path: <linux-kernel-owner+w=401wt.eu-S1761580AbZJORYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580AbZJORYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbZJORYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:24:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbZJORYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:24:07 -0400
Message-ID: <4AD75A81.90202@zytor.com>
Date: Thu, 15 Oct 2009 10:23:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, bruce.w.allan@intel.com
Subject: Re: Intel DP55KG BIOS Bug (reboot hangs, is Intel aware of the problem?)
References: <alpine.DEB.2.00.0910141756440.2653@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.0910141756440.2653@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 03:02 PM, Justin Piszcz wrote:
> Hi,
> 
> I have tried the following kernel parameters with '*' and reboot=b,
> reboot=h and reboot=s.
> 

reboot=t (triple), reboot=p (pci) and reboot=a (acpi) would be useful to
test, too.

	-hpa
