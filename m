Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbZKLNOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbZKLNOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 08:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZKLNOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 08:14:34 -0500
Received: from nox.protox.org ([88.191.38.29]:37270 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZKLNOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 08:14:34 -0500
Subject: Re: [PATCH] drm/radeon/kms: Add default 800x600 mode when getting
 bad EDID
From: Jerome Glisse <glisse@freedesktop.org>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <1258016979-2083-1-git-send-email-jglisse@redhat.com>
References: <1258016979-2083-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Nov 2009 14:11:55 +0100
Message-Id: <1258031515.2473.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 10:09 +0100, Jerome Glisse wrote:
> Adding default 800x600 mode should be a safe fail solution in front
> of broken EDID, user can then add new mode to fit its needs.
> 
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>

Forget this patch a better one is coming.

Cheers,
Jerome Glisse

