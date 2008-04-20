Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbYDTTNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbYDTTNp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbYDTTNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:13:36 -0400
Received: from science.horizon.com ([192.35.100.1]:11205 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755885AbYDTTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:13:36 -0400
Message-ID: <20080420191318.12214.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 20 Apr 2008 15:13:18 -0400
To: rjw@sisk.pl, linux@horizon.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       len.brown@intel.com
Subject: Re: 2.6.25 regression: 60417f5976df breaks Thinkpad suspend
References: <20080415115326.9915.qmail@science.horizon.com>
 <200804161937.25557.rjw@sisk.pl>
In-Reply-To: <200804161937.25557.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> This change has been reverted from the current Linus' tree, so please check
> if 2.6.25-rc9 (or a later git snapshot) works for you.

With apologies for the long delay (I was in the middle of a lengthy debug
session I didn't want to lose to install a new kernel), yes 2.6.25-rc9 works
fine.

Thank you very much!
