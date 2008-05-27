Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbYE0FyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbYE0FyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYE0FyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:54:09 -0400
Received: from qmta02.westchester.pa.mail.comcast.net ([76.96.62.24]:37538
	"EHLO QMTA02.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724AbYE0FyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:54:08 -0400
X-Authority-Analysis: v=1.0 c=1 a=XcPHcaD5O6wA:10 a=ViHLxJBvJ0IA:10
 a=29PYjEz0rYImhiAskOsA:9 a=bt0BeyZ1qPMuEOAE5V5ON1TGlboA:4 a=LY0hPdMaydYA:10
From: Dmitry Torokhov <dtor@insightbb.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/4] wm97xx-core: Report a phys for WM97xx touchscreens
Date: Tue, 27 May 2008 01:54:03 -0400
User-Agent: KMail/1.9.3
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805270154.04707.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 May 2008 09:42, Mark Brown wrote:
> phys is displayed in diagnostic output like that from evbug so ensure
> that it is set to something.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied all 4 to "for-linus" branch. Thank you Mark.

-- 
Dmitry
