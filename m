Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYGQGfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYGQGfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 02:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYGQGfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 02:35:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:46210 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYGQGfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 02:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:user-agent:from;
        b=YIG+ZN1fm6PzX0qnH3WSJ9EeKQhEYUMZG45H+i7QA6hfoq2LTJwBGd9uXYQtq2BUl0
         b3Ag+CU/1MfLDKeEOPeWyv71B0uSO4GpvfB0vkrF+0OD5Sv5YFK70Cyek9iXgWEddrgw
         9xpDpYZhLOd/uoY2du+9rjhqHoCRcDiBxi9Ps=
Date: Thu, 17 Jul 2008 08:35:40 +0200
To: jrigby@freescale.com, grant.likely@secretlab.ca
Cc: linux-kernel@vger.kernel.org
Subject: FRED=42
Message-ID: <20080717063540.GA25608@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, jrigby@freescale.com,
	grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John, Grant,

can you please remove that "FRED=42" line from the top kernel Makefile since it
seems it sneaked in unwanted with the rest of the commit?

Thanks.

-- 
Regards/Gruﬂ,
    Boris.
