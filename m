Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYDFQau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYDFQau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 12:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYDFQam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 12:30:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:41657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbYDFQam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 12:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=DPS6Us38Vs5lfMxkBXF9xLkwquDfW49aDISqvK0g7UYkIcTSCWUGbVyeIy2ElM2BH9waHjJy2S1A7DEeasMNcLQ1GRLauz4HgXXltNddZKP35ECKCaszapb5bBI+9n2h2Ro8Qz6zqEx0gaCzxy0/GpX/+dv1ZzZ2952emzNo4+U=
Message-ID: <a72f6a3c0804060930l157ec1f5xc090dfdc3ca4a011@mail.gmail.com>
Date: Sun, 6 Apr 2008 17:30:40 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: How does Linux measure CPU frequency?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to find out how Linux calibrates the frequency of CPUs, and
want to compare with the way how lmbench measures processor frequency.
I had a thorough google search of this topic but didn't get too much
useful results.

Thanks a lot,
Jack
