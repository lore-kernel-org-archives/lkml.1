Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYBKAKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYBKAKy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYBKAKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:10:46 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:59957 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751621AbYBKAKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:10:45 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: 2.6.24.x-stable request for 69f817b654d683265118188bbfb8bc0d8978cce6 and ece8edddf067d21c4e5abfe3f1205da1588edbb2
Date: Mon, 11 Feb 2008 02:08:56 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20080201.769323)
Cc: flamingice@sourmilk.net, johannes@sipsolutions.net, jbenc@suse.cz,
       hschaa@suse.de, yi.zhu@intel.com, linville@tuxdriver.com,
       jgarzik@pobox.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802110208.58891.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

On 2.6.24.1-stable kernel review cycle, i requested inclusions of commit 69f817b654d683265118188bbfb8bc0d8978cce6 (mac80211: Restore rx.fc before every invocation of ieee80211_invoke_rx_handlers) and ece8edddf067d21c4e5abfe3f1205da1588edbb2 (mac80211: hardware scan rework) into -stable one (they solved disable_hw_scan=1 workaround for wpa_secured hidden AP problem). And -stable team said they would rather these comes from either the wireless maintainer or the network maintainer to verify that they are needed, and the backports works properly.

So, if possible, could you please consider sending these to -stable?

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
