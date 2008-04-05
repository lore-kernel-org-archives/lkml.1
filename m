Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbYDEQIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbYDEQIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 12:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbYDEQIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 12:08:05 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:56002 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYDEQIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 12:08:04 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: Re: sata_via
Date: Sat, 5 Apr 2008 19:08:30 +0300
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804051908.30540.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rich,

What is the output of command:

grep CONFIG_IRQBALANCE .config

If:

CONFIG_IRQBALANCE=y

try disabling it.

Regards

Marin Mitov
