Return-Path: <linux-kernel-owner+w=401wt.eu-S1762297AbXEYMyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297AbXEYMyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 08:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbXEYMy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 08:54:28 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:57859
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751552AbXEYMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 08:54:28 -0400
Date: Fri, 25 May 2007 14:56:30 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/2] use list_for_each() for iteration in hostap and prism54 driver
Message-ID: <20070525125630.GE31790@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset uses the list_for_each() macro instead of manual
iteration in the following drivers:

Host AP
Prism54

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona


  The salvation of mankind lies only in making everything the concern of all
                         (Alexander Solzhenitsyn)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
