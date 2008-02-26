Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbYBZSQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbYBZSQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763134AbYBZSPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:15:52 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58487 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762984AbYBZSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:15:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C45749.3010001@s5r6.in-berlin.de>
Date: Tue, 26 Feb 2008 19:15:37 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: -next build logs
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

the allmodconfig builds at http://kisskb.ellerman.id.au/kisskb/branch/9/ 
seem to lack a few drivers even though they are properly enabled in the 
respective config.  Is it simply because everything is rebuilt on top of 
a previous build?

Do you mail only errors to maintainers or also compiler warnings?

Thanks,
-- 
Stefan Richter
-=====-==--- --=- ==-=-
http://arcgraph.de/sr/
