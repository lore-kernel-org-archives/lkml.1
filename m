Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbZLPP2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbZLPP2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762258AbZLPP16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:27:58 -0500
Received: from fencepost.gnu.org ([140.186.70.10]:46665 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762256AbZLPP15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:27:57 -0500
Date: Wed, 16 Dec 2009 10:27:56 -0500
From: Davidlohr Bueso <dave@gnu.org>
To: jochen@scram.de
Cc: linux-kernel@vger.kernel.org
Subject: DIO bus driver usage
Message-ID: <20091216152755.GA18517@fencepost.gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jochen,

I was doing some fixes to the DIO linux driver you wrote (drivers/dio/*) but was wondering if this driver is even in usage. I can't seem to see it compiled even using allyesconfig.

Thanks.

   Davidlohr
