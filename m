Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbYDCGZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbYDCGZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 02:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757059AbYDCGY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 02:24:57 -0400
Received: from main.gmane.org ([80.91.229.2]:45579 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032AbYDCGY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 02:24:57 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jon Masters <jonathan@jonmasters.org>
Subject: Re: Real time USB2Serial devices and behaivor
Date: Thu, 03 Apr 2008 02:24:30 -0400
Message-ID: <1207203870.12035.1.camel@perihelion>
References: <20080326152559.GA17164@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: boston.jonmasters.org
In-Reply-To: <20080326152559.GA17164@linux.intel.com>
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 08:25 -0700, mark gross wrote:

> BTW Why does the PL2303 have a 1KB buffer for incoming data?

Personally, RT or not, I really like to avoid using those PL230X parts.
They're everywhere, this is true, but also quite horrible sometimes.

Jon.



