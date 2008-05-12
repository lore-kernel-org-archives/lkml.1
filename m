Return-Path: <linux-kernel-owner+w=401wt.eu-S1757627AbYELW5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbYELW5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbYELW4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:56:46 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:32073 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757431AbYELW4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:56:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=soDJTuaOAGMhg5z+x2nk4H3w3MoRmukoFJam0uGZiAICDBIVK2Kt4Li2JZ4LqNVDKnuGdMdU9Dlo1OwLtYYiLaz+dUsjiyTXFbxtkOqOit8uT7PHQo9k1XP0EffmH+FbyA6cUcEZRSYxq0t6NvpClfk9CafUlzCAWuzra0jbWfY=  ;
X-YMail-OSG: hmqZE5MVM1nmlyyaYvjZ2LJmVaX3KN0bQdFEJV70UC.vpyjd4TjkTlhfEy0Scj3FBrfoma_1qRBfIbOGFJgMjt7LQyK2PlK.TZuS7LPheqHVszqKEatFVUWI3nckbIcBOco-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Grant Likely" <grant.likely@secretlab.ca>
Subject: Re: [PATCH/RFC] spi: Change modalias from a pointer to a character array
Date: Mon, 12 May 2008 15:56:39 -0700
User-Agent: KMail/1.9.6
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <20080509173146.2932.16141.stgit@trillian.secretlab.ca> <20080512151805.4c2763b9.akpm@linux-foundation.org> <fa686aa40805121520y979ee37ga83221b74b35afe1@mail.gmail.com>
In-Reply-To: <fa686aa40805121520y979ee37ga83221b74b35afe1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200805121556.40042.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2008, Grant Likely wrote:
> >
> >  I'm not really able to work out if this is a needed-in-2.6.26 thing.  I
> >  assumed "not".
> 
> That's correct.  I'm also not even 100% sure that this is the best
> approach.  I'm waiting/hoping for feedback from David.

You'll get some.  Unlike your other patch, this one wasn't
obvious and required me to burn a few grey cells ... ones
which have been otherwise occupied.  ;)

- dave

