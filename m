Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbXJ3VP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbXJ3VP4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 17:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbXJ3VPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 17:15:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbXJ3VPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 17:15:47 -0400
Message-ID: <47279EF7.3040406@redhat.com>
Date: Tue, 30 Oct 2007 17:15:35 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-kernel@vger.kernel.org,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: Huawei E220 and usb storage
References: <20071030190945.GC32153@gamma.logic.tuwien.ac.at> <20071030211729.6a80a93a.Kristoffer.ericson@gmail.com> <20071030204720.GI8479@gamma.logic.tuwien.ac.at>
In-Reply-To: <20071030204720.GI8479@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2007 04:47 PM, Norbert Preining wrote:
> Hi Kristoffer,
> 
> thanks for the feedback.
> 
> On Di, 30 Okt 2007, Kristoffer Ericson wrote:
>> Im using a Huawei E220 USB modem, currently running 2.6.22.5 vanilla kernel. It has worked fine for me since 2.6.21.
> 
> Strange. I rebuilt the kernel, compiled the usb serial and options into
> the kernel, while leaving usb-storage as module. Still I have to issue
> the huaweiAktBbo program to get it working/switching into the *right*
> modus.
> 

Did you see commit d853d872c14b9adc4adad29e56cd378b291f86e0 ?
