Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYKDLZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYKDLZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 06:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYKDLZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 06:25:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:37761 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbYKDLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 06:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KCoVqqkdoEYrMHXk8ouFwNnUh1zfa+vuMhEQfujZ6B4NDTB6SX5Hme1ug7QN6E8Fka
         NzQBvw3xa9FfSm5lCsYL6AtW+5KqsygsXynpW87Q5FeXAu8/QdWX56WM+f8OojMf4mUU
         W0fA2W4ygy6RFmS7uqREz13C2j4fQ3jShYyvE=
Message-ID: <e2e108260811040325y2fd7f9f7ic627c17b3866f1ad@mail.gmail.com>
Date: Tue, 4 Nov 2008 12:25:36 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: ext2/3 vs. kingston 32G SD card
Cc: "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081104110225.GB4514@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081104110225.GB4514@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 12:02 PM, Pavel Machek <pavel@suse.cz> wrote:
> If I suspect wrong block device, what are useful tests to run there?

Tools like xdd allow to write certain data patterns to a block device
and to verify the written data.

Bart.
