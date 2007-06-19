Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbXFSQSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbXFSQSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbXFSQRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:17:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758572AbXFSQRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:17:51 -0400
Message-ID: <467801A4.4030004@redhat.com>
Date: Tue, 19 Jun 2007 12:17:40 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
CC: linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Error -71 on device descriptor read/all
References: <4677EBF8.5020104@mandic.com.br>
In-Reply-To: <4677EBF8.5020104@mandic.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2007 10:45 AM, Renato S. Yamane wrote:
> Hi,
> I see this in dmesg:
> usb 1-1: device descriptor read/all, error -71
> 
> Using 2.6.21.1
> 
> Someone know what it is?
> 

Try disabling CONFIG_USB_SUSPEND

[usb developers: what are the drawbacks of doing this?]
