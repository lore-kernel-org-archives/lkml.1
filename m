Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbYG0Vti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbYG0Vti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 17:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758579AbYG0Vta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 17:49:30 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:35949 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757614AbYG0Vta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 17:49:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2rndQQRu8S+E/fru9HVMQsGzHZZVgcwfs1HyfX1eqYhDfUgp15VFbGCVydURGIVhvdv38gdPdTeUl7WC+5LyKbTFuTY85QgDu5AiOejp3vNIjtiwFrksXz/d/jvSRL5f56adoLRQyapcQyl9eZL2qsnxy41ScR6CLWAPikPb8RY=  ;
X-YMail-OSG: mKsj87sVM1m8LPEwLlidZDN27hNrCQi1g4S7DxdZd39VnuI28_loqKGiiaRE_P_budga9MZ8GIesT0gNCpYJrHnUIRUFDpeXCV6g5yLjAECPgR_7ULGEQNuM14W1bRIeREo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v3 0/4 REPOST] OF infrastructure for SPI devices
Date: Sun, 27 Jul 2008 14:49:28 -0700
User-Agent: KMail/1.9.9
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linuxppc-dev@ozlabs.org, jonsmirl@gmail.com
References: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
In-Reply-To: <20080725072549.8485.90723.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807271449.28472.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008, Grant Likely wrote:
> I don't know what to do with these patches.  I'd really like to see them
> in .27, and now that akpm has cleared his queue, the prerequisite patch
> has been merged so they are ready to go in.  However, even though there
> has been favourable reception on the SPI and linuxppc lists for these
> changes I don't have any acks from anybody yet.
> 
> David, can you please reply on if you are okay with these patches
> getting merged?  If so, do you want me to merge them via my tree, or
> do you want to pick them up?

OK ... to recap, #1 and #3 are OF-specific, I'll be agnostic.
If other OF folk think it's OK, great.

Some cleanup was needed for #2, but it was basically ok ...
I'd like to see the final version, and if it goes via an
OF push that's OK by me.  (Though I'd like to see that change
make it into 2.6.27 regardless, so let me know.)

And #4 isn't quite cooked yet.
