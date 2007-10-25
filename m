Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXJYDqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXJYDqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 23:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757103AbXJYDqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 23:46:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13028 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbXJYDqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 23:46:19 -0400
Message-ID: <47201183.1090107@schaufler-ca.com>
Date: Wed, 24 Oct 2007 20:46:11 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Version 9 (2.6.24-rc1) Smack: Simplified Mandatory Access
 Control Kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The Smack patch and Paul Moore's netlabel API patch,
together for 2.6.24-rc1. Paul's changes are identical
to the previous posting, but it's been a while so they're
here again.

The sole intent of change has been to address locking
and/or list processing issues. Please don't hesitate to
point out any problems that you might see or suggest
alternatives where things might not be to your liking.

This version is aimed at 2.6.24, and has been tested
against 2.6.24-rc1.

Thank you again.
