Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbYGJM6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbYGJM6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYGJM6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:58:11 -0400
Received: from bu3sch.de ([62.75.166.246]:46141 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbYGJM6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:58:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Drivers for selfmade hardware
Date: Thu, 10 Jul 2008 14:57:47 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200806292147.52112.mb@bu3sch.de> <20080709224557.45a85ff5.akpm@linux-foundation.org>
In-Reply-To: <20080709224557.45a85ff5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101457.47529.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 July 2008 07:45:57 Andrew Morton wrote:
> #else
> #define btgpio_suspend NULL
> #define btgpio_resume NULL

Yeah I thought you had a patch in -mm which does this. Don't you?


-- 
Greetings Michael.
