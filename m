Return-Path: <linux-kernel-owner+w=401wt.eu-S1763338AbXJXRJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763338AbXJXRJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbXJXRJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:09:05 -0400
Received: from flatline.sindominio.net ([82.144.4.26]:54053 "EHLO
	flatline.sindominio.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbXJXRJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:09:04 -0400
Date: Wed, 24 Oct 2007 19:08:58 +0200
From: matthias.kaehlcke@gmail.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/3] MBCS: Convert semaphores to the mutex API
Message-ID: <20071024170858.GH9824@traven>
Mail-Followup-To: matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

MBCS: Convert the semaphores algolock, dmareadlock and dmawritelock to the 
mutex API

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
