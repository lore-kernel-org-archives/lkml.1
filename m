Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbYEaIaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbYEaIaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbYEaI3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:29:55 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51974 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbYEaI3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:29:54 -0400
Date: Sat, 31 May 2008 10:30:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Clifford Wolf <clifford@clifford.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add 'make no2modconfig' config generation target
Message-ID: <20080531083034.GA2569@uranus.ravnborg.org>
References: <1212217507-32126-1-git-send-email-clifford@clifford.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212217507-32126-1-git-send-email-clifford@clifford.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 09:05:07AM +0200, Clifford Wolf wrote:
> The new 'make no2modconfig' make target creates a new kernel
> config based on the current one, switching all tristate options
> from 'n' to 'm'.

Hi Clifford.

In what situations do we need this functionality?

	Sam
