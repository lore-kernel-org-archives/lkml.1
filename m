Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYLKVQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYLKVQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbYLKVQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:16:10 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:17001 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862AbYLKVQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R2ChK1U7d/CTbWdjBNNhAizAfx4l6ktVH6zAv+6bErgY6WitTp9lV4h9VtxLAE0e75
         sB3kMDQfQ49smOrM4MkLvIW3bEQnakxpRzlgzSC7l17Q+fHNE2PdZMz8DYbrqxHjFF5o
         tE9U12lpzQ1tI+qW2P9Ti8tWQFpdtV9DfM8+w=
Message-ID: <55fdf7050812111316q57aca4a2idfe3caae4b1244ce@mail.gmail.com>
Date: Thu, 11 Dec 2008 13:16:04 -0800
From: "LINUX NEWBIE" <lnxnewbie@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org
Subject: Re: Add new capture device driver in Linux
In-Reply-To: <4936B4C7.909@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <55fdf7050812021644o3bffc326n1eedfb699c2a141c@mail.gmail.com>
	 <4936B4C7.909@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

    Thanks.  Where can I find an example of a basic PCIe analog
capture driver?  Basically what does a basic PCIe capture driver need?

Thank you again.


On Wed, Dec 3, 2008 at 8:33 AM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> LINUX NEWBIE wrote:
>>      How do I add a new capture device driver similar to cx23885?
>
> Specific documentation and developer contacts:
>    http://www.linuxtv.org/
>
> General advice:
>    linux/Documentation/SubmittingDrivers ("Resources" section)
> furthermore
>    linux/Documentation/HOWTO
>    linux/Documentation/development-process/
>    linux/MAINTAINERS
> and when you are ready to submit the driver
>    linux/Documentation/SubmittingPatches
>    linux/Documentation/SubmitChecklist
> --
> Stefan Richter
> -=====-==--- ==-- ---==
> http://arcgraph.de/sr/
>
