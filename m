Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbYGQXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbYGQXSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbYGQXSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:18:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:55045 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759363AbYGQXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:18:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MiKdtFkvvDoMWrvLwsMnVRphsnHTH15j5mqUcwYYaIvywmbQh9cS5sFi2Dnu6Y3Q0l
         AReBUsRV7QL7yr03y6bG2sXH4ubBt5Oj7QUJo2SY441lOLD+oHoKU06pm2VQ4sAMJRez
         yU8nJDdT9y+wwsOsq5QEm61Hc1j4aURq7Cdh4=
Message-ID: <86802c440807171618hdecfe4cyebba5bd65d28d894@mail.gmail.com>
Date: Thu, 17 Jul 2008 16:18:29 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: empty smpcommon_32.c
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is renamed to smpcommon.c

but old one with one blank line still sit the tree.

YH
