Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYJ2Ta1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYJ2Ta1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 15:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYJ2TaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 15:30:14 -0400
Received: from Ext-cn0ut-7.online-age.net ([63.210.253.237]:23391 "EHLO
	ext-cn0ut-7.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662AbYJ2TaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 15:30:13 -0400
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2008 15:30:13 EDT
Date: Wed, 29 Oct 2008 20:20:45 +0100
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: linux-kernel@vger.kernel.org
Subject: reiserfs_warning() spamming the syslog
Message-ID: <20081029192045.GA4481@kipc2.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
X-GEHealthcare-MailScanner: Found to be clean
X-GEHealthcare-MailScanner-From: karl.kiniger@med.ge.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

after two external USB drives got disconnected by powering off 
a third USB drive  I got several thousand lines of spam in the log:

Oct 29 19:02:15 kipc2 kernel: ReiserFS: sdf1: warning: zam-7001: io error in reiserfs_find_entry

(current Fedora 9 kernel, i686)

rate limiting those would be nice.

Greetings,
Karl
-- 
D.I. Karl Kiniger     mailto:karl.kiniger@med.ge.com
Tel: (++43) 7682-3800-710  Voip(GE): 1662 710
Fax: (++43) 7682-3800-47 C: +43 6991 3800 710
-
GE Medical Systems Kretztechnik GmbH & Co OHG - Tiefenbach 15 – A-4871 Zipf
Landesgericht Wels FN 222387s – UID (VAT-ID): ATU54086108 - DVR: 2111103 – ARA: 12816
Persönlich haftende Gesellschafterin: GE Medical Systems Kretztechnik GmbH
Tiefenbach 15 – A-4871 Zipf  - Landesgericht Wels FN 218689b
