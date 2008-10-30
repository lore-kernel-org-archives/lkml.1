Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYJ3QSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYJ3QSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYJ3QRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:17:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:59892 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbYJ3QRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:17:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=nbNvtluhce8unN4kTIEjYumKlf1txfsHXgnFzMAoWQISo2/shtrtf3eUqEYLQeh4/9
         0YUi0TgOXpShXfQozuEJ1KwC86VTCv9MQy+EBhU1fI3gfVW/XkFXtcVL75E4J0BZavMO
         Y84Ac8tg+G5NR/1AH1XEIlNVSSUjBlhvfaoVA=
Message-ID: <b6c5339f0810300917i25b4164fof2ba51569d4e7012@mail.gmail.com>
Date: Thu, 30 Oct 2008 12:17:48 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Stefan Hellermann" <stefan@the2masters.de>
Subject: Re: pull request: wireless-2.6 2008-10-29
Cc: "John W. Linville" <linville@tuxdriver.com>,
       "Arjan van de Ven" <arjan@infradead.org>, davem@davemloft.net,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mcgrof@gmail.com, mickflemm@gmail.com
In-Reply-To: <4909C93E.7020400@the2masters.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081029231855.GD3485@tuxdriver.com>
	 <20081029162324.28f5864d@infradead.org>
	 <20081029233350.GE3485@tuxdriver.com>
	 <4909C93E.7020400@the2masters.de>
X-Google-Sender-Auth: cac5158624990f71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 10:48 AM, Stefan Hellermann
<stefan@the2masters.de> wrote:
> I think some of the reports on kerneloops are from my machine, I'm
> running wireless-testing#master in the hope to get my card fully
> working. It's a AR2425 chip (MAC: 0xe2, PHY: 0x70), in a Lenovo Notebook.

Okay, I just added a bugzilla for this:

http://bugzilla.kernel.org/show_bug.cgi?id=11901

I can reproduce it here after all...
-- 
Bob Copeland %% www.bobcopeland.com
