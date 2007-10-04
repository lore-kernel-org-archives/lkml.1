Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbXJDSX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbXJDSX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759352AbXJDSXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:23:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:19828 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbXJDSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:23:06 -0400
Message-ID: <47052F88.4070702@schaufler-ca.com>
Date: Thu, 04 Oct 2007 11:23:04 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: "casey@schaufler-ca.com >> Casey Schaufler" 
	  <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: torvalds@osdl.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org, paul.moore@hp.com
Subject: [PATCH 0/2] Version 5 (2.6.23-rc8-mm2) Smack: Simplified Mandatory
 Access Control Kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I have broken the Smack patch into the netlabel changes from Paul Moore
(1/2) and the Smack LSM (2/2), at Paul's kind suggestion.

The smackfs symlinks have proven too contentious. I have removed the
facility. Al and Alan are correct that the rich set of mount options
currently available can handle any of the use cases I was looking at
without excessive difficulty.

I think that is the last of the major issues. I'm sure that if there
are more y'all will let me know.

Thank you.



