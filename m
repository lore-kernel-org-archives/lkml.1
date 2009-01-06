Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbZAFAzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbZAFAzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 19:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZAFAzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 19:55:05 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4134 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZAFAzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 19:55:03 -0500
Subject: Re: [PATCH v2] ASPM: Use msleep instead of cpu_relax during link
 retraining
From: Joe Perches <joe@perches.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, matthew@wil.cx,
       akpm@linux-foundation.org, shaohua.li@intel.com
In-Reply-To: <1231203276.20557.175.camel@localhost>
References: <20090105230716.15081.29984.stgit@bob.kio>
	 <1231203276.20557.175.camel@localhost>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 16:55:54 -0800
Message-Id: <1231203354.20557.178.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't notice you already sent v3.

