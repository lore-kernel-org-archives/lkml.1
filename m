Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbZD2B1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbZD2B1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZD2B1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:27:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60082 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbZD2B1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:27:40 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: linux-crypto@vger.kernel.org
Subject: [PATCH 0/2] crypto: ansi_cprng self-test infra and vectors
Date: Tue, 28 Apr 2009 21:27:32 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       Neil Horman <nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904282127.33190.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be able to use ansi_cprng in fips mode, we need to run ansi_cprng
self-tests before it can be used.

[PATCH 1/2] add infrastructure for ansi_cprng self-tests
[PATCH 2/2] add ansi_cprng test vectors

-- 
Jarod Wilson
jarod@redhat.com
