Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbYFLVHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbYFLVHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYFLVH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:07:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41405 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYFLVH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:07:27 -0400
Message-ID: <48518FE8.8000308@zytor.com>
Date: Thu, 12 Jun 2008 14:06:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: David Altobelli <david.altobelli@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HP iLO driver
References: <20080612182308.GA1091@ldl.fc.hp.com>  <48516CF2.106@zytor.com> <1213301632.17870.75.camel@violet.holtmann.net>
In-Reply-To: <1213301632.17870.75.camel@violet.holtmann.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> 
> this is udev's job.
> 

Yes and no.  udev, as it should, defaults to the namespace used by sysfs.

	-hpa
