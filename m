Return-Path: <linux-kernel-owner+w=401wt.eu-S1758902AbZCMNr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758902AbZCMNr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbZCMNrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:47:18 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:47398 "EHLO pardus.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753859AbZCMNrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:47:17 -0400
Message-ID: <49BA6364.6040407@pardus.org.tr>
Date: Fri, 13 Mar 2009 15:45:08 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Capability to do correct frequency throttling and PM when the cpufreq
 drivers are compiled into kernel
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is the mainline kernel fully capable of detecting the processor model/family for
using the correct power management stuff when all the cpufreq, powernow*, acpi_processor,
etc. are made into kernel instead of loadable modules?

Or more precisely, can we get totally rid of the userspace init scripts which probes, loads, tweaks power management modules by parsing some /proc files, when we make them in-kernel?

Thanks,

-- 

Ozan Çağlayan
<ozan_at_pardus.org.tr>
