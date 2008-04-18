Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbYDRUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbYDRUCT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbYDRUCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:02:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933324AbYDRUCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:02:05 -0400
Message-ID: <4808FE39.6040700@redhat.com>
Date: Fri, 18 Apr 2008 16:02:01 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.25 booting under VMware: "WARNING: strange, CPU MTRRs all blank?"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code was added to suppress this warning under kvm
(4147c8747eace9058c606b35e700060297edaf91) but vmware still
causes the warning.
