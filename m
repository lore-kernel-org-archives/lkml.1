Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbYLJSdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbYLJSdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbYLJS3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:29:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63188 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbYLJS3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:29:04 -0500
Message-ID: <49400A4E.7040107@vlnb.net>
Date: Wed, 10 Dec 2008 21:28:30 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH][RFC 1/23]: SCST public headers
References: <494009D7.4020602@vlnb.net>
In-Reply-To: <494009D7.4020602@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19xMFw4g0zrIxan4q2N9Wx1H8A4wQ6e3HeJbHN
 tfzbfzfaek4ZmeqagxkJ273iaG1C0YXwe5Dg4d8pcg9LdBWEcM
 UXnExqZE8xIw+vqL0JUVw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains declarations of all externally visible constants, 
types and functions prototypes.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  include/scst/scst.h       | 2676 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  include/scst/scst_const.h |  316 ++++++
  2 files changed, 2992 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_public_headers.diff


