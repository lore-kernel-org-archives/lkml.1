Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbZIHTvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbZIHTvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbZIHTvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:51:48 -0400
Received: from mail-iw0-f201.google.com ([209.85.223.201]:52567 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZIHTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:51:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=OBsfNG7jUXvxg5J2yrKBOORlm6ciQztJd+Rup8AJC3ezwk6cz2cUk/2wNNLHCpUPAb
         CopcEo0GAFSsRIMqNKpmw2HGoq5l1N+AuO8ajs28X1iwtOJ8r00khnnLzLANp09CZFHS
         w3DsR6BWuCsFJvjEitJOLySy1y/TRBX/tXWkE=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 8 Sep 2009 12:30:31 -0700
Message-ID: <43e72e890909081230h420c2abi125a6fbfc2777250@mail.gmail.com>
Subject: 2.6.27 maintenance plans after 2.6.32 is released
To: Greg KH <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>
Cc: stable-review@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was curious if 2.6.27 is planned to be supported after 2.6.32 is
released, or will that be dropped in favor for 2.6.28 as the last
supported kernel. How does dropping an old kernel for stable
maintenance consideration typically work?

  Luis
