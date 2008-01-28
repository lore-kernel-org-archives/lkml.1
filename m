Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbYA1T6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbYA1T6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYA1T6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:58:17 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:43290 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYA1T6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:58:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VGVnBkPUeS5nzNhPYlJoTnGim1D5WT+1hq0keBylRHJ5V2YrG5XPs4+x6jrlcrDJ9++xXORyXDFD9fpiIaPykz1zdtg6l043Wn85R0yrH24jbGegNNBEf/l4VKTMhwLtuFXKNBaoL7I+/draA/MpXZ+YnlOrEP8PWdCoEsI0y4o=
Message-ID: <83f15e30801281158s36b0da3el210f5a97b0348ea3@mail.gmail.com>
Date: Mon, 28 Jan 2008 14:58:12 -0500
From: "Jason Price" <japrice@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: show label for swap partition.
In-Reply-To: <83f15e30801281156od91c2a8p3ec439cb16232386@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83f15e30801281151w21466ef9m82dc50ab09dc390f@mail.gmail.com>
	 <83f15e30801281156od91c2a8p3ec439cb16232386@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize if this is the wrong forum.  Please CC me on replies.

A admin accidentally deleted the swap line from the fstab file.  We
mount the swap filesystem via labels.  However, there seems to be no
way to list the label on an existing swap partition, via the command
line swap tools (mkswap, swapon/off, etc)

Is this blindness on my part, or should there be an analog to e2label
for swap partitions?

--Jason
