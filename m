Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZCTIQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZCTIQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZCTIQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:16:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:62836 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZCTIQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Q8tRWYG3giftynYmVm+qPa1HL7zVUOptFjRKSHvcWjeGVwC1x5O7u8JvqJ4Y1pUlM6
         BkIxyMc15sxsXU6nSwVRf4s0I+POpK6mQL5cSQg393K9X4W2JM1XjdIoBXQnTV2Kvu6d
         C+xUkhFtbP6EOx1AxrzKripIV3TmUar5zwTjY=
Date: Fri, 20 Mar 2009 01:16:33 -0700
From: Shentino <shentino@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: question about pt locking
Message-ID: <20090320081633.GA673@shentino-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just curious, but does a process effectively have a read-lock on its 
page tables when it's in userland?

-- a curious newbie

