Return-Path: <linux-kernel-owner+w=401wt.eu-S1765783AbXGLDVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765783AbXGLDVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 23:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756257AbXGLDVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 23:21:44 -0400
Received: from blargh.com ([24.234.115.147]:41134 "EHLO blargh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755435AbXGLDVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 23:21:43 -0400
References: <courier.4689EFD9.0000589A@blargh.com>
            <200707040908.21512.ak@suse.de>
            <courier.468B579E.00002ECF@blargh.com>
            <200707041038.57677.ak@suse.de>
            <468B5FBD.3040104@gmail.com>
            <469365B2.9020809@suse.de>
In-Reply-To: <469365B2.9020809@suse.de>
From: 7091@blargh.com
To: Tejun Heo <teheo@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, Andi Kleen <ak@suse.de>, 7091@blargh.com,
       linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sata_sil, writing bug with multiple cards?
Date: Wed, 11 Jul 2007 20:21:42 -0700
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Message-ID: <courier.46959E46.00000E8F@blargh.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo writes: 

> Please give a shot at the attached patch on top of 2.6.22.  Thanks.

Patch applied, but still getting the corruption.
