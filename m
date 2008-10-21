Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbYJUVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbYJUVx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYJUVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:53:20 -0400
Received: from phunq.net ([64.81.85.152]:42813 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750966AbYJUVxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:53:19 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned htree hash algorithms
Date: Tue, 21 Oct 2008 14:53:11 -0700
User-Agent: KMail/1.9.5
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1224560624-9691-1-git-send-email-tytso@mit.edu> <1224560624-9691-2-git-send-email-tytso@mit.edu> <200810211450.59184.phillips@phunq.net>
In-Reply-To: <200810211450.59184.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810211453.11194.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excuse me,

> +static __u32 uchar_hack_hash (const char *name, int len)

I meant:

+static __u32 uchar_hack_hash(const unsigned char *name, int len)

Regards

Daniel
