Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbZCFWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbZCFWnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZCFWnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:43:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:48429 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZCFWnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:43:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cGV4xy+uVxpYmyUkjdiF1rvLeAZP1k3xyITuI4fsqHM6JKIH8pL3hYc5EmiSFYr7so
         ZWsxhgWyeE7kWgg3k6NOwxOcO77hZ6pz/0jObyiHEAqjngx2ydy7KROffSIuzGLUcV2G
         b0bjI8w2CNAe/xR7H1h867IzWZ56uXNGvdbyQ=
MIME-Version: 1.0
In-Reply-To: <20090306143826.fbbbf56c.akpm@linux-foundation.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	 <1236321780-28718-16-git-send-email-cooloney@kernel.org>
	 <20090306143826.fbbbf56c.akpm@linux-foundation.org>
Date: Fri, 6 Mar 2009 17:43:03 -0500
Message-ID: <8bd0f97a0903061443m5b6b1396gf2bb81c0a181dd58@mail.gmail.com>
Subject: Re: [PATCH 15/18] Blackfin Serial Driver: merge the upstream 
	adeos/xenomai
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, rpm@xenomai.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

just drop this patch.  this was supposed to be merged with some other
code but Yi hasnt had a chance to do it yet.
-mike
