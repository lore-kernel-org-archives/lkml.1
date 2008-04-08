Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbYDHNEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbYDHNEy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYDHNEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:04:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:54845 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbYDHNEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=d+cajSYDXDHfizBv/9BRX8t0+niEEa2ye1ecMwTL6ayGxavN5AEfNJaLNXZACYD7d7dmatMjdEnLzPrASwz9DujH4TbDlQ823TZj9PzdZtQSUfUZjHizL7DZKnb7ts2C7H/8XHYov6kjwHNr70gZB/FIeT6dCxFmyUIEQq43dkg=
Message-ID: <b82a89170804080604r61521340k1086a6fb17bc42e4@mail.gmail.com>
Date: Tue, 8 Apr 2008 18:34:43 +0530
From: "Niraj kumar" <niraj17@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Question] what is equivalent of inact_dirty and inact_clean in 2.6.x kernel
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't have much knowledge about VM subsystem, but I need to find
out if in 2.6.x kernel there is any equivalent of inact_dirty and
inact_clean fields
which are present in /proc/meminfo in 2.4  kernels ?

Maybe if there is nothing (in 2.6.x) equivalent then if
there is anything which is closest in meaning to these fields?
Maybe we can calculate these from other fields?


Thanks
Niraj
