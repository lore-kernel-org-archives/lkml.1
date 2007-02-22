Return-Path: <linux-kernel-owner+w=401wt.eu-S1751398AbXBVCaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbXBVCaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:30:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXBVCaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:30:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXBVCaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:30:13 -0500
Message-ID: <45DD0031.9010808@redhat.com>
Date: Wed, 21 Feb 2007 21:30:09 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: module-init-tools-3.3-pre10 available
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

After some delay[0] I have uploaded a new version of module-init-tools 
to http://www.kerneltools.org/

This release mostly has a bunch of build fixes, some memory leakage 
cleanups that will benefit systems that actually run out of memory 
(embedded, etc.) and various other things in the changelog.

I plan on a non-pre release soon but need a bit more time to go over the 
current code and look at the tests, etc. Patches welcome, as usual.

Jon.

[0] Suspected mononucleosis...oh such a joyful experience :-)
