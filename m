Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab0BYS1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:27:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:55199 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214Ab0BYS1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:27:38 -0500
Subject: Re: Gianfar driver failing on MPC8641D based board
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <4B86A97E.6050509@ge.com>
Date: Thu, 25 Feb 2010 12:27:21 -0600
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sandeep Gopalpet <Sandeep.Kumar@freescale.com>, davem@davemloft.net
Content-Transfer-Encoding: 7bit
Message-Id: <1446F46F-683F-49F7-BBD4-2113A26B0DAB@kernel.crashing.org>
References: <4B6C2488.3060403@ge.com> <4B865176.7080806@ge.com> <4B86A97E.6050509@ge.com>
To: Martyn Welch <martyn.welch@ge.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 25, 2010, at 10:46 AM, Martyn Welch wrote:

> 
> Further testing has shown that this isn't restricted to warm reboots, it
> happens from cold as well. In addition, the exact timing of the failure
> seems to vary, some boots have got further before failing.

what mechanism do you use for warm resets?

- k
