Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXFAQqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXFAQqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762034AbXFAQqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:46:45 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:35523 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762124AbXFAQqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=QbQM3kwGGv+8vR5LNSmvHnQ6f/LiQyqzM9EclebI+1N0bUoUHxFLKLKPDMWmuw7k+VmZvY94xFfPPNsNY+YnDyitXdISa03jlztsULIH6lBO561CPIU/c2MAVkO70I/ULFG5EyWjCGdB2xNLJqgItA3Nurl7MeJ/iJrMR/v5nco=
Message-ID: <3634de740706010946iabd6c51rf7e9a36463e3fca3@mail.gmail.com>
Date: Fri, 1 Jun 2007 22:16:41 +0530
From: Maximus <john.maximus@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: dma_alloc_coherent fails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Am using a linux 2.6.19 kernel for arm. the dma_alloc_coherent
function call in the kernel for 38400 bytes fails.


Has anyone faced this problem before?.


What could be make dma_alloc_coherent to success sometimes and fail sometimes?.

Regards,
John
