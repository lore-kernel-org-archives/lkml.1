Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbXLMAje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbXLMAje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 19:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbXLMAj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 19:39:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbXLMAj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 19:39:26 -0500
Message-ID: <47607F35.9090004@zytor.com>
Date: Wed, 12 Dec 2007 16:39:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Aras Vaichas <arasv@magtech.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: mmaping an IO port device
References: <4760727E.2090906@magtech.com.au>
In-Reply-To: <4760727E.2090906@magtech.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aras Vaichas wrote:
> Hi,
> 
> Can I implement mmap with an io port connected device on an x86 based CPU?
> 

No.

	-hpa
