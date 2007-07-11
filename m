Return-Path: <linux-kernel-owner+w=401wt.eu-S934801AbXGKXP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbXGKXP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933913AbXGKXPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:15:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:61826 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933463AbXGKXPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,528,1175497200"; 
   d="scan'208";a="249298281"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: S3 state transition
Date: Wed, 11 Jul 2007 16:15:37 -0700
Message-ID: <A3258B497F1C1441AD36A2E8B45FD628486D78@scsmsx412.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: S3 state transition
Thread-Index: AcfEEWPdE5k8GTIyTZ28MVwu+alCIg==
From: "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Jul 2007 23:15:39.0022 (UTC) FILETIME=[64EEFAE0:01C7C411]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to understand how Linux handles S3 state transition.
Specially I want to understand what it does anything for processes
loaded at the time of transition. Any pointers to code/document will be
helpful.

Thanks,
Lomesh
