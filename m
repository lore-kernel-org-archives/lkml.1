Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYAPSpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYAPSpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 13:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYAPSpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 13:45:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYAPSpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 13:45:43 -0500
Message-ID: <478E4F90.7060808@zytor.com>
Date: Wed, 16 Jan 2008 13:40:16 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: EDD hangs
References: <20080116182419.2e5087bd@lxorguk.ukuu.org.uk>
In-Reply-To: <20080116182419.2e5087bd@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On a box here the kernel hangs on boot without "edd=off". Adding printfs
> as hpa suggested shows that it correctly scans BIOS disk 1 (0x80) then on
> disk 2 (PDC20263) it gets a version then hangs trying to read the MBR

Is there a disk connected to the PDC20263 and its BIOS enabled?

	-hpa
